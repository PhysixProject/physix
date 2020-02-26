extern crate clap; 
use clap::{Arg,App};
use std::process::Command;
use std::fs::File;
//use flate2::read::GzDecoder;
//use tar::Archive;
use std::io::{BufRead, BufReader};

fn verify_tools() { 
    println!("Checking for required system tools");
    
    let tool_lst = [ "mkfs.ext3", "gcc", "g++", "make", "gawk", "bison" ];
    for tool in tool_lst.iter() { 
        let status = Command::new("which")
            .arg(tool)
            .status()
            .expect("failed to execute process");

        if ! status.success() {
            panic!("Required tool Note Found: {}", tool);
        }
        else {
            println!("Found: {}",tool);
        }
    }
}


/* Not tested
 * https://rust-lang-nursery.github.io/rust-cookbook/compression/tar.html
*/
fn unpack(archive: &str) {
    // Check it exists
    let tar_path = "/mnt/physix/src/physix/sources/" + archive

    let tar_gz = File::open(path)?;
    let tar = GzDecoder::new(tar_gz);
    let mut archive = Archive::new(tar);
    archive.unpack(".")?;

    Ok(())

}


fn build_toolchain() {

    let filename = "/home/travis/1-build_toolchain.csv";
    // Open the file in read-only mode (ignoring errors).
    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);

    // Read the file line by line using the lines() iterator from std::io::BufRead.
    for (index, line) in reader.lines().enumerate() {
        let line = line.unwrap(); // Ignore errors.
        let ln_vec:Vec<&str> = line.split(",").collect();
        let ln_len = ln_vec.len();

        if ln_len == 3 {
            let subtree = ln_vec[0];
            let script = ln_vec[1];
            let src0 = ln_vec[2]; 
            println!("\nCommand: /mnt/physix/physix/{}/{} {}",subtree,script,src0);
            unpack(src0);
        }
        else if ln_len == 4 {
            let subtree = ln_vec[0];
            let script = ln_vec[1];
            let src0 = ln_vec[2];
            let src1 = ln_vec[3];
            println!("\nCommand: /mnt/physix/physix/{}/{} {} {}",subtree,script,src0,src1); 
        }

    }


}


fn ingest_build_conf() {

    let filename = "./build.conf";
    // Open the file in read-only mode (ignoring errors).
    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);


    // open build.conf
    // turn it into a map
    // return the map

}


fn main() { 
    let matches = App::new("physix-tool")
       .version("0.001")
       .about("Performs Admin opperations for Physix OS")
       .author("Travis Davies")

       .arg(Arg::with_name("build-prep")
            .long("build-prep")
            .value_name("FILE")
            .help("Prepares build using build.conf")
            .takes_value(true))

        .arg(Arg::with_name("build-toolchain")
            .long("build-toolchain")
            .value_name("FILE")
            .help("build temporary toolchain")
            .takes_value(true))

        .arg(Arg::with_name("build-base")
            .long("build-base")
            .value_name("FILE")
            .help("Builds base system using toolchain")
            .takes_value(true))

        .arg(Arg::with_name("install")
            .long("install")
            .value_name("FILE")
            .help("install package list")
            .takes_value(true))
       .get_matches(); 


    if matches.is_present("build-prep") {
           let config = matches.value_of("build-prep").unwrap_or("build.conf");
           println!("An input file was specified {}", config);
           verify_tools();
    }

    if matches.is_present("build-toolchain") {
           let config = matches.value_of("build-toolchain").unwrap_or("1-build_toolchain.csv");
           println!("An input file was specified {}", config);
           build_toolchain();

           ingest_build_conf(); 

    }

    if matches.is_present("build-base") {
           let config = matches.value_of("build-base").unwrap_or("2-build-base-sys.csv");
           println!("An input file was specified {}", config);
    }

}

