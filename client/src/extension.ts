/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */

import * as path from 'path';
import * as os from 'os';
import { workspace, ExtensionContext, env } from 'vscode';

import {
	LanguageClient,
	LanguageClientOptions,
	ServerOptions,
} from 'vscode-languageclient';
import { openSync } from 'fs';

let client: LanguageClient;

export function activate(context: ExtensionContext) {
	let language = env.language;

	// Options to control the language client
	let clientOptions: LanguageClientOptions = {
		// Register the server for plain text documents
		documentSelector: [{ scheme: 'file', language: 'lua' }],
		synchronize: {
			// Notify the server about file changes to '.clientrc files contained in the workspace
			fileEvents: workspace.createFileSystemWatcher('**/.clientrc')
		}
	};

	let command: string;
	let platform: string = os.platform();
	switch (platform) {
		case "win32":
			command = context.asAbsolutePath(
				path.join('server', 'Windows', 'bin', 'lua-language-server.exe')
			);
			break;
		case "linux":
			command = context.asAbsolutePath(
				path.join('server', 'Linux', 'bin', 'lua-language-server')
			);
			break;

		case "darwin":
			command = context.asAbsolutePath(
				path.join('server', 'Macos', 'bin', 'lua-language-server')
			);
			break;
	}
	
	let serverOptions: ServerOptions = {
		command: command,
		args: [
			'-E',
			'-e',
			'LANG="' + language + '"',
			context.asAbsolutePath(
				path.join('server', 'main.lua')
			)
		]
	};

	client = new LanguageClient(
		'Lua Language Server',
		'Lua Language Client',
		serverOptions,
		clientOptions
	);

	client.start();
}

export function deactivate(): Thenable<void> | undefined {
	if (!client) {
		return undefined;
	}
	return client.stop();
}
