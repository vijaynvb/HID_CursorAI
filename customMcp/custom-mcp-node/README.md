# MCP Project

This repository demonstrates a simple server implementation using the **Model Context Protocol (MCP) SDK** with Node.js and Express. It provides a reference for integrating and using the MCP SDK to expose tools and resources over the Model Context Protocol.

## Features

- **Express-based HTTP server** exposing an MCP endpoint
- **Session management** for MCP clients
- **MCP tools**: Addition, Energy Prices, Todos
- **MCP resource**: Greeting
- **TypeScript** for type safety

## Getting Started

### Prerequisites

- Node.js (v18 or later recommended)
- npm

### Installation

1. Clone the repository:

   ```sh
   git clone <this-repo-url>
   cd my-mcp
   ```

2. Install dependencies:

   ```sh
   npm install
   ```

3. Build the project:

   ```sh
   npm run build
   ```

4. Start the server:

   ```sh
   npm start
   ```

   The server will run at [http://localhost:3000](http://localhost:3000).

## Using the Model Context Protocol SDK

This project uses the [`@modelcontextprotocol/sdk`](https://www.npmjs.com/package/@modelcontextprotocol/sdk) to implement an MCP server. The SDK allows you to define tools (functions) and resources (data endpoints) that can be called by MCP clients.

### Key Concepts

- **McpServer**: Main class to register tools and resources.
- **StreamableHTTPServerTransport**: Handles HTTP(S) transport and session management.
- **Tools**: Functions exposed to MCP clients (e.g., add, get-energy-prices, get-todos).
- **Resources**: Data endpoints with URI templates (e.g., greeting resource).

## Code Overview

The main logic is in [`src/index.ts`](src/index.ts):

**1.** **Express App Setup**: Initializes an Express server and configures JSON parsing.

**2.** **Session Management**: Maintains a map of active MCP sessions and their transports.

**3.** **MCP Endpoint**: Handles `/mcp` POST requests for MCP communication. Initializes a new session if needed, or reuses an existing one.

**4.** **McpServer Initialization**: Registers tools and resources:

- `add`: Adds two numbers (parameters: `a`, `b`).
- `get-energy-prices`: Fetches energy prices from an external API.
- `get-todos`: Fetches a list of todos from a public API.
- `greeting` resource: Returns a greeting message for a given name.

**5.** **Session Cleanup**: Handles GET (SSE) and DELETE (session termination) requests for session management.

**6.** **Server Startup**: Listens on port 3000.

### Example: Defining a Tool

```typescript
server.tool("add", { a: z.number(), b: z.number() }, async ({ a, b }) => ({
  content: [{ type: "text", text: String(a + b) }]
}));
```

### Example: Defining a Resource

```typescript
server.resource(
  "greeting",
  new ResourceTemplate("greeting://{name}", { list: undefined }),
  async (uri, { name }) => ({
    contents: [{
      uri: uri.href,
      text: `Hello, ${name}!`
    }]
  })
);
```

## Extending the Server

You can add more tools or resources by calling `server.tool` or `server.resource` with your own logic. See the [MCP SDK documentation](https://www.npmjs.com/package/@modelcontextprotocol/sdk) for more details.

## Using the MCP Server in Cursor IDE


You can interact with the MCP server directly from the Cursor IDE using HTTP tools, MCP-compatible clients, or by configuring the `.cursor/mcp.json` file for seamless integration.

### Using `.cursor/mcp.json` for MCP Integration

The `.cursor/mcp.json` file allows you to register MCP servers tools. This enables quick access to your MCP endpoints from within the editor.
**Example `.cursor/mcp.json`:**

```json
{
    "mcpServers": {
        "my-server-mcp": {
            "url": "http://localhost:3000/mcp"
        }
    }
}
```

- Place this file in your project's `.cursor` directory.
- Update the `url` to match your local or deployed MCP server endpoint.
- Some Cursor IDE MCP integrations will automatically detect and let you interact with the registered servers.

**Tip:** You can register multiple servers by adding more entries under `servers`.

---