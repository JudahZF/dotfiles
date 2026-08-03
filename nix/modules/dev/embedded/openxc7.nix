# Open-source Xilinx 7-series FPGA toolchain (openXC7) for Zynq-7000 boards:
#   yosys          synthesis
#   nextpnr-xilinx place & route ($ZYNQ7_CHIPDB holds the xc7z010 chipdb)
#   prjxray/fasm   FASM -> frames -> bitstream (fasm2frames, xc7frames2bit)
#   openFPGALoader board programming over Digilent onboard JTAG
#   iverilog + surfer for simulation and waveform viewing
#
# The exported variables match what the openXC7 demo-project Makefiles expect
# (https://github.com/openXC7/demo-projects).
{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  xc7 = inputs.openxc7.packages.${system};
  # openXC7's own nixpkgs, so the Python env matches the interpreter its fasm
  # package was built against and binaries substitute from cache.nixos.org.
  xc7Pkgs = inputs.openxc7.inputs.nixpkgs.legacyPackages.${system};

  # fasm's antlr C parser backend aborts in libffi trampoline allocation on
  # aarch64-darwin; raising here makes it fall back to the pure-python
  # textx parser (slower, but fine at hobby-design scale).
  fasmTextx = xc7.fasm.overridePythonAttrs (old: {
    postPatch = old.postPatch + ''
      substituteInPlace fasm/parser/__init__.py \
        --replace-fail "available.append('antlr')" \
          "raise ImportError('antlr backend disabled: libffi crash on darwin')"
    '';
  });

  pyEnv = xc7Pkgs.python312.withPackages (
    ps: with ps; [
      fasmTextx
      cython
      textx
      pyyaml
      simplejson
      intervaltree
    ]
  );

  # prjxray's python tools need the fasm env on PYTHONPATH; bake it into the
  # executables instead of polluting the global PYTHONPATH.
  prjxrayWrapped = xc7Pkgs.symlinkJoin {
    name = "prjxray-wrapped";
    paths = [ xc7.prjxray ];
    nativeBuildInputs = [ xc7Pkgs.makeWrapper ];
    postBuild = ''
      for tool in $out/bin/*; do
        wrapProgram "$tool" --prefix PYTHONPATH : ${pyEnv}/${pyEnv.sitePackages}
      done
    '';
  };

  # yosys finds share/ relative to the resolved executable path, which breaks
  # under the profile's symlink farm; an exec shim keeps argv[0] in the store.
  yosysWrapped = xc7Pkgs.symlinkJoin {
    name = "yosys-wrapped";
    paths = [ xc7Pkgs.yosys ];
    nativeBuildInputs = [ xc7Pkgs.makeWrapper ];
    postBuild = ''
      for tool in $out/bin/yosys*; do
        rm "$tool"
        makeWrapper ${xc7Pkgs.yosys}/bin/$(basename "$tool") "$tool"
      done
    '';
  };

  # Upstream's zynq7 chipdb derivation builds every Zynq footprint and
  # currently fails on the larger parts (missing xc7z035+ fabric data in
  # prjxray-db), so generate the chipdb for just the xc7z010. Add more
  # bbaexport/bbasm pairs here for other parts (e.g. xc7z020clg400-1).
  zynq7010Chipdb =
    xc7Pkgs.runCommand "nextpnr-xilinx-chipdb-xc7z010"
      {
        nativeBuildInputs = [
          xc7.nextpnr-xilinx
          xc7Pkgs.pypy310
        ];
      }
      ''
        mkdir -p $out
        pypy3.10 ${xc7.nextpnr-xilinx}/share/nextpnr/python/bbaexport.py \
          --device xc7z010clg400-1 --bba xc7z010.bba
        bbasm -l xc7z010.bba $out/xc7z010.bin
      '';
in
{
  environment.systemPackages = [
    xc7.nextpnr-xilinx
    prjxrayWrapped
    yosysWrapped
    xc7Pkgs.openfpgaloader
    xc7Pkgs.iverilog
    xc7Pkgs.surfer
  ];

  environment.variables = {
    NEXTPNR_XILINX_DIR = "${xc7.nextpnr-xilinx}";
    NEXTPNR_XILINX_PYTHON_DIR = "${xc7.nextpnr-xilinx}/share/nextpnr/python/";
    PRJXRAY_DB_DIR = "${xc7.nextpnr-xilinx}/share/nextpnr/external/prjxray-db";
    ZYNQ7_CHIPDB = "${zynq7010Chipdb}";
    # Carry-chain routing is broken in current nextpnr-xilinx
    # (openXC7/nextpnr-xilinx#97); openXC7.mk picks this up. Drop the
    # workaround once upstream fixes the regression.
    SYNTH_OPTS = "-nocarry";
  };
}
