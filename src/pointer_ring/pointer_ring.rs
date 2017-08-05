/*
rustc pointer_ring.rs -O -o pointer_ring_rust
*/
#![feature(rand)]

use std::env;
extern crate rand;
use std::__rand::thread_rng;
use rand::distributions::{IndependentSample, Range};
// use std::time::precise_time_ns;
use std::time::Instant;

fn main() {
    for argument in env::args() {
        println!("{}", argument);
    }

    let args: Vec<String> = env::args().collect();
    let buffersize: usize = args[1].parse().unwrap();
    let iterations: usize = args[2].parse().unwrap();

    let mut buffer: Vec<usize> = (1..(buffersize+1)).into_iter().collect();
    // make last go to first
    buffer[buffersize-1] = 0;

    let range = Range::new(0, buffersize);
    let mut rng = thread_rng();

    println!("randomizing buffer");
    for _ in 0..(10*buffersize) {
        let idx1 = range.ind_sample(&mut rng);
        let idx2 = range.ind_sample(&mut rng);

        // start with:
        // a -> b -> c
        // d -> e -> f
        let a = buffer[idx1];
        let b = buffer[a];
        let c = buffer[b];
        let d = buffer[idx2];
        let e = buffer[d];
        let f = buffer[e];

        // end with:
        // a -> e -> c
        // d -> b -> f
        buffer[a] = e;
        buffer[d] = b;
        buffer[b] = f;
        buffer[e] = c;
    }

    let start = Instant::now();

    let mut idx = buffer[0];
    for _ in 0..iterations {
        idx = buffer[idx];
        // println!("value: {}", idx);
    }
    println!("final value: {}", idx);

    let end = Instant::now();
    let duration = end.duration_since(start);
    let nanoseconds = (duration.subsec_nanos() as f64) + 1e9 * (duration.as_secs() as f64);
    println!("time: {}", nanoseconds);
}
