# Twelve Labs Codex Plugin

An [OpenAI Codex](https://github.com/openai/codex) plugin for [Twelve Labs](https://twelvelabs.io) video AI. Index videos, search them with natural language, generate summaries and chapters, create multimodal embeddings, and recognize specific people or objects — all from within Codex.

## Features

- **Search** — Find moments in videos using natural language, images, or both
- **Analyze** — Generate summaries, chapters, highlights, and Q&A from video content
- **Index** — Add videos from URLs, local files, or entire folders
- **Embeddings** — Generate 512-dimensional multimodal video embeddings
- **Entity Search** — Recognize and find specific people or objects across videos

## Requirements

- Node.js 18+
- [OpenAI Codex CLI](https://github.com/openai/codex)
- A Twelve Labs API key — get one at [dashboard.twelvelabs.io](https://dashboard.twelvelabs.io)

## Install

1. Set your API key:

```bash
export TWELVELABS_API_KEY="tlk_YOUR_KEY_HERE"
```

2. Run the install script:

```bash
bash install.sh
```

This copies the plugin to `~/.codex/plugins/twelvelabs` and registers it in `~/.agents/plugins/marketplace.json`.

3. Launch Codex, type `/plugins`, select **Twelve Labs**, and install it.

## Usage

The plugin activates automatically when your prompt involves video. No special syntax required.

### 1. Create an Index

An index is where your videos live. You need one before you can upload anything.

```
Create a new video index called "product-demos"
```

### 2. List Indexes

See what indexes you already have.

```
List my video indexes
```

### 3. Index a Video

Add a video to an index from a local file, URL, or Google Drive link.

```
Index /path/to/video.mp4 into my product-demos index
```

```
Index this video into product-demos: https://example.com/video.mp4
```

```
Index all videos in /path/to/folder/ into product-demos
```

### 4. Check Indexing Status

Videos take a few minutes to process. Check if they're ready.

```
Is my video done indexing?
```

```
Check the status of my indexing tasks
```

### 5. List Videos in an Index

```
List the videos in my product-demos index
```

### 6. Search

Search within an index using natural language.

```
Search my product-demos index for "a person giving a presentation"
```

```
Search for "someone cooking" in my default index
```

### 7. Analyze a Video

Generate summaries, chapters, highlights, or ask questions about a specific video.

```
Summarize the key points of the "Q3 Planning" video
```

```
Generate chapters with timestamps for my latest indexed video
```

```
What products are shown in the "product-launch" video?
```

### 8. Entity Search

Recognize specific people or objects within an index. Create a collection, upload reference images, create an entity, then search.

```
Create an entity collection called "engineering team"
```

```
Upload this photo as a reference image: /path/to/alice.jpg
```

```
Create an entity called "Alice" with that reference image
```

```
Search my product-demos index for where Alice appears
```

### 9. Generate Embeddings (Advanced)

Create 512-dimensional multimodal embeddings from a video URL, local file, or already-indexed video. Useful for building custom similarity search, clustering, or classification pipelines.

```
Generate embeddings for the "product-launch" video in my product-demos index
```

## Architecture

This plugin uses stdio MCP transport to run the [Twelve Labs MCP Server](https://github.com/twelvelabs-io/twelve-labs-mcp-server) locally via `npx`. All 19 tools work out of the box, including local file upload — no remote server required.

## Uninstall

Inside Codex, run `/plugins`, select Twelve Labs, and uninstall. Then clean up:

```bash
rm -rf ~/.codex/plugins/twelvelabs
```

Remove the `twelvelabs` entry from `~/.agents/plugins/marketplace.json`.

