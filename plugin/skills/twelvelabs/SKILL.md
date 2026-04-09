---
name: twelvelabs
description: Use when the user wants to search inside videos, analyze video content, index new videos, generate video embeddings, or find specific people/objects in videos using the Twelve Labs video AI platform.
---

# Twelve Labs

Twelve Labs is a video AI platform. It lets you index videos, search them with natural language, analyze content, generate multimodal embeddings, and recognize specific people or objects.

## Prerequisites

1. **API Key**: The `TWELVELABS_API_KEY` environment variable must be set before launching Codex.
   ```bash
   export TWELVELABS_API_KEY="your-api-key"
   ```
   Get a key at https://dashboard.twelvelabs.io

2. **Node.js 18+**: Required to run the MCP server via `npx`.

## Required Workflow

Follow these steps in order:

1. **Check for an index** — Use `list-indexes` to see existing indexes.
2. **Create an index if needed** — Use `create-index`. Choose `embedding` model for search/embeddings, `generative` for analysis, or both (default).
3. **Index a video** — Use `start-video-indexing-task` with a URL, local file path, or folder path.
4. **Wait for indexing** — Use `get-video-indexing-tasks` to poll status until `Ready`.
5. **Use the video** — Search, analyze, or generate embeddings.

## Available Tools

### Index Management

| Tool | Purpose | Key Parameters |
|------|---------|---------------|
| `create-index` | Create a video index | `name`, `models` (generative/embedding), `addons` |
| `list-indexes` | List all indexes | `page` |
| `delete-index` | Delete an index | `indexId` |

### Video Indexing

| Tool | Purpose | Key Parameters |
|------|---------|---------------|
| `get-sample-videos` | Get curated test videos with URLs | _(none)_ |
| `start-video-indexing-task` | Index a video from URL, local file, or folder | `videoUrl`, `videoFilePath`, `folderFilePath`, `indexId`, `userMetadata` |
| `get-video-indexing-tasks` | Check indexing task status | `taskId` |
| `list-videos` | List videos in an index | `indexId`, `page` |

### Search

| Tool | Purpose | Key Parameters |
|------|---------|---------------|
| `search` | Natural language video search | `query`, `indexId`, `queryMediaUrl`, `queryMediaFile`, `queryMediaType` |

Search supports three modes:
- **Text only**: Just provide `query`
- **Image only**: Provide `queryMediaUrl` or `queryMediaFile` with `queryMediaType: "image"`
- **Composed (text + image)**: Provide both `query` and an image for refined results (Marengo 3.0)
- **Entity search**: Use `<@entity_id> action description` as the query

### Analysis

| Tool | Purpose | Key Parameters |
|------|---------|---------------|
| `analyse-video` | Generate text from video (summaries, chapters, Q&A) | `videoId`, `prompt` |

The video must be indexed first. Use `list-videos` to find the `videoId`.

### Embeddings

| Tool | Purpose | Key Parameters |
|------|---------|---------------|
| `start-video-embeddings-task` | Generate video embeddings | `videoUrl`, `videoFilePath` |
| `get-video-embeddings-tasks` | Check embedding task status | `taskId` |
| `retrieve-video-embeddings` | Get the embedding vectors | `taskId` or `indexId` + `videoId` |

### Entity Search (People/Object Recognition)

| Tool | Purpose | Key Parameters |
|------|---------|---------------|
| `create-entity-collection` | Create a collection for grouping entities | `name` |
| `list-entity-collections` | List all entity collections | _(none)_ |
| `delete-entity-collection` | Delete a collection and all its entities | `collectionId` |
| `create-asset` | Upload a reference image for entity recognition | `imageUrl`, `imageFile` |
| `create-entity` | Create a recognizable person/object | `collectionId`, `name`, `assetIds` |
| `list-entities` | List entities in a collection | `collectionId` |
| `delete-entity` | Delete an entity | `collectionId`, `entityId` |

## Practical Workflows

### Search for a moment in videos

```
1. list-indexes → find the index
2. search(query: "person running through a field", indexId: "...") → get matching segments with timestamps
```

### Analyze a video

```
1. list-videos(indexId: "...") → find the videoId
2. analyse-video(videoId: "...", prompt: "Generate a summary with chapters and timestamps")
```

### Index a video from URL

```
1. list-indexes → find or create-index
2. start-video-indexing-task(videoUrl: "https://example.com/video.mp4", indexId: "...")
3. get-video-indexing-tasks(taskId: "...") → poll until Ready
```

### Index a local video file

```
1. list-indexes → find or create-index
2. start-video-indexing-task(videoFilePath: "/path/to/video.mp4", indexId: "...")
3. get-video-indexing-tasks(taskId: "...") → poll until Ready
```

### Batch index a folder of videos

```
1. list-indexes → find or create-index
2. start-video-indexing-task(folderFilePath: "/path/to/videos/", indexId: "...")
3. get-video-indexing-tasks → check all task statuses
```

### Find a specific person in videos (Entity Search)

```
1. create-entity-collection(name: "My Team")
2. create-asset(imageUrl: "https://example.com/photo.jpg") → get assetId
3. create-entity(collectionId: "...", name: "Alice", assetIds: ["..."]) → get entityId
4. search(query: "<@entityId> is giving a presentation", indexId: "...")
```

### Generate embeddings

```
1. start-video-embeddings-task(videoUrl: "https://example.com/video.mp4")
2. get-video-embeddings-tasks(taskId: "...") → poll until ready
3. retrieve-video-embeddings(taskId: "...") → get 512-dim vectors
```

## Query Engineering Tips

1. **Be specific**: "ballet dancer performing on a stage with dim lighting" not "dancer"
2. **Use natural language**: "footage where a guitarist plays a solo" not "guitar, solo, concert"
3. **Try synonyms**: "car" or "vehicle" instead of "automobile"
4. **Translate jargon**: "player jumping over another player" instead of "hurdle"
5. **Specify shot types**: "aerial shot with time-lapse showing city lights at dusk"

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "API key not found" | Set `TWELVELABS_API_KEY` env var before launching Codex |
| Indexing stuck on "Pending" | Normal — wait 1-2 minutes for worker allocation |
| Search returns no results | Ensure videos are indexed (status: Ready) and query matches visual/audio content |
| "No default index found" | Create an index first with `create-index` or specify `indexId` explicitly |
| Local file upload fails | Verify the file path is absolute and the file exists |
| Entity search not working | Requires Marengo 3.0 model. Use format: `<@entity_id> action` |
