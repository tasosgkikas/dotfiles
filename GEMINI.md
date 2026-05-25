# ♊ Gemini CLI Project Instructions

These rules govern the development and maintenance of the `dotfiles` project. Following these ensures consistency, safety, and alignment with the project's "instantly deployable" philosophy.

## 🌿 Git & Branching
- **Branch Naming:** Use the format `<number>-<category>/<description>` (e.g., `12-feature/dart-flutter`).
- **Protect Main:** Never perform development or configuration work directly on the `main` branch. The only exceptions are updates to `TODO.md` (roadmap) and `GEMINI.md` (instructions).
- **Keep Local Branches:** Do not delete local feature/task branches after merging. Keep them to preserve local development history.
- **Scope Purity:** If a task requires changes that are outside the scope of the current branch, do not perform them immediately. Instead, create a new ticket in `TODO.md` and address them on a separate, dedicated branch.
- **No Rushing:** Prioritize thoroughness over speed. Do not rush to commit or finish a task without comprehensive verification.
- **Commit Strategy:** Perform small, surgical commits. Grouping related changes (e.g., configuration and its installer) is preferred, but large feature branches should be broken down.
- **Remote Operations:** Do not push to remote repositories unless explicitly instructed.

## 📋 Project Management
- **Roadmap:** Maintain a Jira-style Kanban board in `TODO.md`.
- **Status Sections:** Use full titles: `🚧 In Progress`, `🎯 Selected for Development`, `💤 Backlog`, and `✅ Done`.
- **Ticket Codes:** Use simple numbers in brackets (e.g., `[12]`) for all tasks.
- **Marking as Done:** A ticket must only be marked as `[x]` (Done) in the `TODO.md` file on the `main` branch **after** the corresponding ticket branch has been successfully pushed upstream and merged into `main`. Never mark a ticket as "Done" without explicit user confirmation that the requirements have been met.

## 🛠️ Engineering Standards
- **Rigorous Testing:** Every change requires empirical verification. Tests must verify not just exit codes, but actual system state and tool behavior.
- **Path Safety:** Always use `"$HOME"` (quoted) instead of `~/` in scripts to ensure proper expansion and handling of spaces.
- **Location Independence:** Installer scripts must calculate the repository root dynamically. Avoid assuming the repo is cloned to `~/dotfiles`.
- **Automation:** Strive for "Headless" setup. Installations should be non-interactive (e.g., using `emacs --batch` for package sync) whenever possible.
- **Idempotency:** All scripts must be safe to run multiple times without corrupting the system or duplicating configuration.

## ✍️ Language-Specific Rules
- **Clojure:** Use CIDER as the primary development environment. `clojure-lsp` is explicitly disabled to prevent performance lag.
- **Flutter:** All Flutter-related tasks must be verified across both Ubuntu 22.04 and 24.04 using the Dockerized test environment.
