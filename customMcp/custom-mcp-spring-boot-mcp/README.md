# Custom MCP Server (Spring Boot) — Cursor IDE Setup Guide

This project is a minimal Model Context Protocol (MCP) server built with Spring Boot and Spring AI. It runs over STDIO and is meant to be launched directly by the Cursor IDE (or any MCP-capable client) via its MCP configuration.

## Prerequisites

- Java 17+ (JDK)
- Maven 3.9+ (or use the included Maven Wrapper `mvnw.cmd`)
- Cursor IDE (or another MCP-capable client) with MCP support

## Build the Server

From the project root:

```powershell
# Using Maven wrapper (recommended on Windows)
./mvnw.cmd -q clean package

# Or using a system Maven
mvn -q clean package
```

The build creates `target/custommcp-0.0.1-SNAPSHOT.jar`.

## How the Cursor IDE Knows About This Server
The file `.vscode/mcp.json` (or your MCP client configuration) tells the Cursor IDE (or another MCP client) to start the server via STDIO:

```jsonc
{
    "mcpServers": {
        "spring-custom-mcp": {
            "type": "stdio",
            "command": "java",
            "args": [
                "-jar",
                "<file-path-name>/target/custommcp-0.0.1-SNAPSHOT.jar"
            ]
        }
    }
}
```

- Server name: `spring-custom-mcp`
- Transport: STDIO (configured in `src/main/resources/application.properties`)
- Logging goes to `./logs/custommcp.log` to keep STDOUT/STDERR clean for MCP

## Run in Cursor IDE

1. Go to the Cursor IDE Settings.
2. Navigate to `Tools and MCP` -> Enable the Spring custom mcp server.
3. Save and restart the Cursor IDE if needed.

## What This MCP Server Provides

The server exposes two tools, implemented in `com.example.custommcp.Util.McpTool`:
- getAllUsersData: Fetches all users from `https://jsonplaceholder.typicode.com/users`
- getAllTodosData: Fetches all todos from `https://jsonplaceholder.typicode.com/todos`

These are registered via `ToolCallbacks.from(mcpTool)` in `CustommcpApplication` and surfaced to the MCP client.

## Configuration Highlights

From `src/main/resources/application.properties`:

- `spring.ai.mcp.server.transport=STDIO` ensures STDIO transport
- `spring.main.web-application-type=none` disables the web server
- `logging.file.name=./logs/custommcp.log` routes logs to a file so STDIO stays protocol-clean

---