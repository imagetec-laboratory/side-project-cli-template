import typer
from rich.console import Console
from rich.table import Table
from typing import Optional

# Create main CLI app
app = typer.Typer(help="Side Project CLI - A powerful command-line tool")
console = Console()

@app.command()
def hello(
    name: str = typer.Argument(..., help="Your name"),
    greeting: Optional[str] = typer.Option("Hello", "--greeting", "-g", help="Greeting message"),
    count: int = typer.Option(1, "--count", "-c", help="Number of times to greet")
):
    """Say hello to someone with a custom greeting."""
    for _ in range(count):
        console.print(f"[bold green]{greeting}[/bold green] [blue]{name}[/blue]! 🎉")

@app.command()
def info():
    """Show project information."""
    table = Table(title="Project Information")
    table.add_column("Field", style="cyan", no_wrap=True)
    table.add_column("Value", style="magenta")
    
    table.add_row("Project Name", "Side Project")
    table.add_row("Version", "0.1.0")
    table.add_row("Description", "A powerful CLI tool")
    table.add_row("Python", ">=3.12.9")
    
    console.print(table)

@app.command()
def version():
    """Show version information."""
    console.print("Side Project CLI [bold]v0.1.0[/bold]")

def main():
    """Entry point for the CLI application."""
    app()

if __name__ == "__main__":
    main()
