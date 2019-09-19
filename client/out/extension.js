"use strict";
/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const os = require("os");
const fs = require("fs");
const vscode_1 = require("vscode");
const vscode_languageclient_1 = require("vscode-languageclient");
let client;
function activate(context) {
    let language = vscode_1.env.language;
    // Options to control the language client
    let clientOptions = {
        // Register the server for plain text documents
        documentSelector: [{ scheme: 'file', language: 'lua' }],
        synchronize: {
            // Notify the server about file changes to '.clientrc files contained in the workspace
            fileEvents: vscode_1.workspace.createFileSystemWatcher('**/.clientrc')
        }
    };
    let beta = vscode_1.workspace.getConfiguration("Lua.zzzzzz").get("cat");
    let command;
    let platform = os.platform();
    switch (platform) {
        case "win32":
            command = context.asAbsolutePath(path.join(beta ? 'server-beta' : 'server', 'Windows', 'bin', beta ? 'lua-beta.exe' : 'lua.exe'));
            break;
        case "linux":
            command = context.asAbsolutePath(path.join(beta ? 'server-beta' : 'server', 'Linux', 'bin', beta ? 'lua-beta' : 'lua'));
            fs.chmodSync(command, '777');
            break;
        case "darwin":
            command = context.asAbsolutePath(path.join(beta ? 'server-beta' : 'server', 'macOS', 'bin', beta ? 'lua-beta' : 'lua'));
            fs.chmodSync(command, '777');
            break;
    }
    let serverOptions = {
        command: command,
        args: [
            '-E',
            '-e',
            'LANG="' + language + '"',
            context.asAbsolutePath(path.join(beta ? 'server-beta' : 'server', 'main.lua'))
        ]
    };
    client = new vscode_languageclient_1.LanguageClient('Lua', 'Lua', serverOptions, clientOptions);
    client.start();
}
exports.activate = activate;
function deactivate() {
    if (!client) {
        return undefined;
    }
    return client.stop();
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map