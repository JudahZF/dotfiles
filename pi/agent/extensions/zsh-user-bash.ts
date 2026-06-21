import { basename } from "node:path";
import {
  createLocalBashOperations,
  type ExtensionAPI,
} from "@mariozechner/pi-coding-agent";

function shellQuote(value: string) {
  return `'${value.replaceAll("'", `'\\''`)}'`;
}

function getZshPath() {
  if (process.env.PI_USER_BASH_SHELL) return process.env.PI_USER_BASH_SHELL;
  if (process.env.SHELL && basename(process.env.SHELL) === "zsh") {
    return process.env.SHELL;
  }
  return "/bin/zsh";
}

function withPortableLocale(env: NodeJS.ProcessEnv = process.env) {
  return {
    ...env,
    // macOS can export Apple/ICU locale identifiers via LC_ALL, e.g.
    // en-GB-u-ca-gregory-co-standard-cu-gbp-fw-mon-hc-h23-ms-uksystem-tz-gblon.
    // Bash/GNU tools launched by Pi do not understand those identifiers and emit
    // `setlocale: LC_ALL: cannot change locale` warnings before zshenv runs.
    LANG: "en_GB.UTF-8",
    LC_ALL: "en_GB.UTF-8",
  };
}

export default function (pi: ExtensionAPI) {
  const local = createLocalBashOperations();

  pi.on("user_bash", () => {
    return {
      operations: {
        exec(command, cwd, options) {
          // Run zsh as a non-interactive shell. `-i` sources ~/.zshrc, which may
          // start prompt integrations like gitstatus/powerlevel10k. Pi executes
          // user bash commands without a real interactive job-control terminal,
          // so those integrations can emit warnings such as:
          //   setopt: can't change option: monitor
          //   gitstatus failed to initialize
          const zshCommand = `exec ${shellQuote(getZshPath())} -fc ${shellQuote(command)}`;
          return local.exec(zshCommand, cwd, {
            ...options,
            env: withPortableLocale(options.env),
          });
        },
      },
    };
  });
}
