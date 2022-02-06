use itertools::{chain, Itertools};
use std::iter::once;
use std::{fs::canonicalize, path::PathBuf};
use structopt::StructOpt;
use anyhow::Result;

extern crate clipboard;

use clipboard::ClipboardProvider;
use clipboard::ClipboardContext;

// note: you will need: sudo apt-get install xorg-dev

#[derive(Debug, StructOpt)]
struct Args {
    #[structopt(short = "c", long = "command", default_value = "mv")]
    command: String,

    #[structopt(long = "header", default_value = "#!/usr/bin/env bash")]
    header: String,

    #[structopt(long = "sep", default_value = "///")]
    sep: String,

    #[structopt(long = "no-copy")]
    nocopy: bool,

    #[structopt(short = "v", long = "verbose")]
    verbose: bool,

    #[structopt()]
    files: Vec<String>,
}

#[paw::main]
fn main(args: Args) -> Result<()> {
    println!("Hello, world!");
    println!("args: {:?}", args);
    println!("command: {:?}", args.command);
    println!("files: {:?}", args.files);

    let Args {
        command,
        files,
        nocopy,
        verbose,
        header,
        sep,
    } = args;

    let absolute_paths: Result<Vec<PathBuf>, _> = files
        .iter()
        .map(|s| canonicalize(s))
        .collect();
    let absolute_paths = absolute_paths?;

    let quoted_absolute_paths = absolute_paths
        .iter()
        .map(|p| p.to_str().unwrap())
        .map(|p| quote_for_shell(p))
        .collect_vec();
    let quoted_filenames = absolute_paths
        .iter()
        .map(|p| p.file_name().unwrap())
        .map(|p| p.to_str().unwrap())
        .map(|p| quote_for_shell(p))
        .collect_vec();

    let max_len = quoted_absolute_paths
        .iter()
        .map(|s| s.len())
        .max()
        .unwrap_or(0);

    let content = chain(
        once(header),
        quoted_absolute_paths
            .iter()
            .zip(quoted_filenames.iter())
            .sorted()
            .map(|(abspath, filename)| {
                format!(
                    " {} {:width$} {}{}",
                    command,
                    abspath,
                    sep,
                    filename,
                    width = max_len
                )
            }),
    )
    .join("\n");

    if verbose {
        println!("{}", content);
    }
    if !nocopy {
        let mut ctx: ClipboardContext = ClipboardProvider::new().unwrap();
        ctx.set_contents(content.clone()).unwrap();
    }
    

    // for (abspath, filename) in quoted_absolute_paths
    //     .iter()
    //     .zip(quoted_filenames.iter())
    //     .sorted()
    // {
    //     println!(
    //         " {} {:width$} {}{}",
    //         command,
    //         abspath,
    //         sep,
    //         filename,
    //         width = max_len
    //     );
    // }

    Ok(())
}

fn quote_for_shell(s: &str) -> String {
    "'".to_owned() + &s.replace("'", "\\'") + "'"
}
