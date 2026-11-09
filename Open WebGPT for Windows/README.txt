# Open WebGPT for Windows

## What this version does

This launcher is designed for the existing **WebGPT Worker** connector already available in ChatGPT.

1. Opens a Windows folder picker.
2. Finds the installed WebGPT skill's `scripts/client.mjs`.
3. Registers a Worker task for the selected project folder.
4. Reuses the same still-running task for the selected folder when available; otherwise registers one.
5. Copies the task token to the clipboard without displaying it. The local session record is DPAPI-protected for the current Windows user.
6. Opens ChatGPT in the default browser.
7. Lets you paste the token once into the intended chat and continue using the same Worker task for later requests.

## Important compatibility note

This is a practical **reusable Worker-task session**, not the token-free Open Mode connection.

Open Mode creates a separate MCP endpoint for each project session. Current OpenAI documentation limits adding custom MCP server connections on ChatGPT web to eligible Business and Enterprise/Edu workspaces; the account available in this conversation is shown as Free. Therefore this package uses the already-connected WebGPT Worker connector instead of pretending that a new custom MCP connection can be registered automatically.

Official references:
- WebGPT Open Mode: https://github.com/Nhahan/WebGPT
- ChatGPT custom MCP connections: https://help.openai.com/en/articles/12584461-connecting-custom-mcp-servers-in-chatgpt

## Requirements

- Windows 10/11.
- Node.js available as `node.exe` on PATH (or in a standard Node.js installation folder).
- WebGPT skill installed in one of the usual Codex locations:
  - `%USERPROFILE%\.codex\skills\webgpt`
  - `%USERPROFILE%\.agents\skills\webgpt`
  - `%CODEX_HOME%\skills\webgpt`
- The WebGPT Worker and its local controller/tunnel services must already be configured and running.
- The WebGPT Worker connector must already be available in ChatGPT.

## Run

Double-click `Open-WebGPT.bat`.

Choose the project folder. When ChatGPT opens, select the **WebGPT Worker** connector, paste the copied token into your first message, then describe the work.

The same token can be reused in that conversation while the Worker task remains running. A ready-to-paste instruction template is included as `FIRST-MESSAGE.txt`. Paste the token into its placeholder before sending. The script sets a 30-day backup-check interval; this is not a promise that a task can never be interrupted or revoked.

To revoke the saved session and cancel its Worker task, run:
`powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\Open-WebGPT.ps1 -Revoke`

To rotate it, run the normal launcher with `-Rotate`; the old saved record is ignored and a new task is registered. If a task was already completed, cancelled, or revoked by the Worker, the launcher automatically registers a fresh task.

## Security

- The task token is a bearer capability. Paste it only into the intended ChatGPT conversation.
- The token is not printed by the script. Its saved session record is encrypted with Windows DPAPI and can be decrypted only by the same Windows user on the same machine.
- The Worker runs as the Windows account that owns the service. The selected project directory is the default working directory, **not a security sandbox**. The Worker can access other files allowed to that Windows account.
- Do not share the token, and do not use this with untrusted chats or instructions.
- To end the session, ask ChatGPT to submit the final outcome through the Worker. Submission closes the task's terminal access.

## Files

- `Open-WebGPT.bat` — double-click launcher.
- `Open-WebGPT.ps1` — folder selection and Worker-session registration.
