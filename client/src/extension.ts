/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */

import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';
import { workspace, ExtensionContext, env } from 'vscode';

import {
	LanguageClient,
	LanguageClientOptions,
	ServerOptions,
} from 'vscode-languageclient';

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

	let beta: boolean = workspace.getConfiguration("Lua.zzzzzz").get("cat");
	let command: string;
	let platform: string = os.platform();
	switch (platform) {
		case "win32":
			command = context.asAbsolutePath(
				path.join(
					beta ? 'server-beta' : 'server',
					'Windows',
					'bin',
					beta ? 'lua-beta.exe' : 'lua.exe'
				)
			);
			break;
		case "linux":
			command = context.asAbsolutePath(
				path.join(
					beta ? 'server-beta' : 'server',
					'Linux',
					'bin',
					beta? 'lua-beta' : 'lua'
				)
			);
			fs.chmodSync(command, '777');
			break;
		case "darwin":
			command = context.asAbsolutePath(
				path.join(
					beta ? 'server-beta' : 'server',
					'macOS',
					'bin',
					beta? 'lua-beta' : 'lua'
				)
			);
			fs.chmodSync(command, '777');
			break;
	}

	let serverOptions: ServerOptions = {
		command: command,
		args: [
			'-E',
			'-e',
			'LANG="' + language + '"',
			context.asAbsolutePath(path.join(
				beta ? 'server-beta' : 'server',
				'main.lua'
			))
		]
	};

	client = new LanguageClient(
		'Lua',
		'Lua',
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
