use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
#[command(propagate_version = true)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Create a new game at specified directory
    New { path: Option<String> },
    /// Run a game at specified game directory
    Run { path: Option<String> },
}

fn main() {
    let cli = Cli::parse();

    // You can check for the existence of subcommands, and if found use their
    // matches just as you would the top level cmd
    match &cli.command {
        Commands::New { path } => {
            println!("New game created at {path:?}")
        }
        Commands::Run { path } => {
            println!("Running game at {path:?}")
        }
    }
}
