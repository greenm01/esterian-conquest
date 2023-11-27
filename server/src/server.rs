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
    /// Create a new game at specified path 
    New { path: Option<String> },
    /// Run server for game specified at path
    Run { path: Option<String> },
    /// Manually run turn maintenance for game at path [TODO]
    Maint { path: Option<String> },
    /// Display statistics for game at path [TODO]
    Stats { path: Option<String> },
}

fn main() {
    let cli = Cli::parse();

    // You can check for the existence of subcommands, and if found use their
    // matches just as you would the top level cmd
    match &cli.command {
        Commands::New { path } => {
            let p = path.as_ref().unwrap();
            println!("New game created at {p:?}")
        }
        Commands::Run { path } => {
            let p = path.as_ref().unwrap();
            println!("Running game at {p:?}")
        }
        Commands::Maint { path } => {
            let p = path.as_ref().unwrap();
            println!("[TODO]: manually run maintenance for game located at {p:?}")    
        }
        Commands::Stats { path } => {
            let p = path.as_ref().unwrap();
            println!("[TODO]: Show game stats for game located at {p:?}")
        }
    }
}
