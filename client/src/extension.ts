/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */

import * as path from 'path';
import { workspace, ExtensionContext, env } from 'vscode';

import {
	LanguageClient,
	LanguageClientOptions,
	ServerOptions,
	TransportKind
} from 'vscode-languageclient';

let client: LanguageClient;

export function activate(context: ExtensionContext) {
	let language = env.language;

	// If the extension is launched in debug mode then the debug server options are used
	// Otherwise the run options are used
	let serverOptions: ServerOptions = {
		run: {
			command: context.asAbsolutePath(
				path.join('server', 'bin', 'lua.exe')
			),
			args: [
				'-E',
				'-e',
				'LANG="' + language + '"',
				context.asAbsolutePath(
					path.join('server', 'main.lua')
				)
			],
			options: {
				cwd: context.asAbsolutePath(
					path.join('server')
				),
			}
		},
		debug: {
			command: context.asAbsolutePath(
				path.join('server', 'bin', 'lua.exe')
			),
			args: [
				'-E',
				'-e',
				'LANG="' + language + '"',
				context.asAbsolutePath(
					path.join('server', 'main.lua')
				)
			],
			options: {
				cwd: context.asAbsolutePath(
					path.join('server')
				),
			}
		}
	};

	// Options to control the language client
	let clientOptions: LanguageClientOptions = {
		// Register the server for plain text documents
		documentSelector: [{ scheme: 'file', language: 'lua' }],
		synchronize: {
			// Notify the server about file changes to '.clientrc files contained in the workspace
			fileEvents: workspace.createFileSystemWatcher('**/.clientrc')
		}
	};

	// Create the language client and start the client.
	client = new LanguageClient(
		'sumneko.lua-lsp',
		'sumneko.lua-lsp',
		serverOptions,
		clientOptions
	);

	// Start the client. This will also launch the server
	client.start();
}

export function deactivate(): Thenable<void> | undefined {
	if (!client) {
		return undefined;
	}
	return client.stop();
}
