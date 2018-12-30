"use strict";
/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const vscode_1 = require("vscode");
const vscode_languageclient_1 = require("vscode-languageclient");
let client;
function activate(context) {
    let language = vscode_1.env.language;
    // If the extension is launched in debug mode then the debug server options are used
    // Otherwise the run options are used
    let serverOptions = {
        run: {
            command: context.asAbsolutePath(path.join('server', 'bin', 'lua-language-server.exe')),
            args: [
                '-E',
                '-e',
                'LANG="' + language + '"',
                context.asAbsolutePath(path.join('server', 'main.lua'))
            ],
            options: {
                cwd: context.asAbsolutePath(path.join('server')),
            }
        },
        debug: {
            command: context.asAbsolutePath(path.join('server', 'bin', 'lua-language-server.exe')),
            args: [
                '-E',
                '-e',
                'LANG="' + language + '"',
                context.asAbsolutePath(path.join('server', 'main.lua'))
            ],
            options: {
                cwd: context.asAbsolutePath(path.join('server')),
            }
        }
    };
    // Options to control the language client
    let clientOptions = {
        // Register the server for plain text documents
        documentSelector: [{ scheme: 'file', language: 'lua' }],
        synchronize: {
            // Notify the server about file changes to '.clientrc files contained in the workspace
            fileEvents: vscode_1.workspace.createFileSystemWatcher('**/.clientrc')
        }
    };
    // Create the language client and start the client.
    client = new vscode_languageclient_1.LanguageClient('sumneko.lua-lsp', 'sumneko.lua-lsp', serverOptions, clientOptions);
    // Start the client. This will also launch the server
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
