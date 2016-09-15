extern crate rustc_serialize;
use rustc_serialize::json;
use rustc_serialize::json::DecodeResult;

use std::io::{self, Read};

mod beans;
use beans::Message;

#[derive(RustcDecodable, RustcEncodable, Debug)]
struct Point {
	x: i32,
	y: i32,
}

#[derive(RustcDecodable, RustcEncodable, Debug)]
pub struct TestStruct  {
	data_int: u8,
	data_str: String,
	data_vector: Vec<u8>,
}

fn main() {

	let mut buffer = String::new();
	io::stdin().read_to_string(&mut buffer);

	// Deserialize using `json::decode`
	let decoded: beans::LocalData = json::decode(&buffer).unwrap();
//	println!("{:?}", decoded);
	println!("{:?}", decoded.messages.len());
}
