fn rand(p: RandomParameters, number_index: u32) -> f32 {
    let stream_offset = p.stream_index * p.numbers_per_stream 
      +  p.vertex_index * NUMBERS_PER_VERTEX 
      + number_index;
    let path_offset = p.local_path_index * p.numbers_per_path + stream_offset;
    let index = u64_add(u64_mul(u64_from(p.iteration), u64_from(p.numbers_per_iteration)), u64_from(path_offset));
    let random_number = squares32(index, p.key);
    if  p.step_type == LARGE_STEP {
        return random_number;
    } else {
        let index = u64_add(p.large_step_index, u64_from(stream_offset));
        let value = squares32(index, p.key);
        let perturbation = SIGMA
          * sqrt(f32(p.small_step_count)) 
          * sqrt(2.0) 
          * erf_inv(2.0 * random_number - 1.0);
        return value + perturbation;
    }
}

fn get_random_parameters(global_path_index: u32, stream_index: u32) -> RandomParameters {
  let path_length = path.length[global_path_index];
  let chain_index = path_length - MIN_PATH_LENGTH;
  let step_type = path.step_type[global_path_index];
  let local_path_index = path.index[global_path_index];
  let vertex_index = path.vertex_index[global_path_index];
  return RandomParameters(
    step_type, 
    local_path_index, 
    chain.numbers_per_path[chain_index], 
    stream_index, 
    chain.numbers_per_stream[chain_index], 
    vertex_index, 
    chain.iteration[chain_index], 
    chain.numbers_per_iteration[chain_index], 
    U64(chain.large_step_index_hi[chain_index], chain.large_step_index_lo[chain_index]), 
    U64(chain.key_hi[chain_index], chain.key_lo[chain_index]),
    chain.small_step_count[chain_index]
  );
}

fn rand_1(global_path_index: u32, stream_index: u32) -> f32 {
  let p = get_random_parameters(global_path_index, stream_index);
  return rand(p, 0);
}

fn rand_2(global_path_index: u32, stream_index: u32) -> vec2f {
  let p = get_random_parameters(global_path_index, stream_index);
  let r1 = rand(p, 0);
  let r2 = rand(p, 1);
  return vec2f(r1, r2);
}

fn rand_4(global_path_index: u32, stream_index: u32) -> vec4f {
  let p = get_random_parameters(global_path_index, stream_index);
  let r1 = rand(p, 0);
  let r2 = rand(p, 1);
  let r3 = rand(p, 2);
  let r4 = rand(p, 3);
  return vec4f(r1, r2, r3, r4);
}

fn u64_from(lo: u32) -> U64 {
    return U64(0, lo);
}

fn squares32(ctr: U64, key: U64) -> f32 {
  var x = u64_mul(ctr, key);
  var y = x;
  var z = u64_add(y, key);

  x = squares32_round(x, y);
  x = squares32_round(x, z);
  x = squares32_round(x, y);
  x = squares32_round(x, z);

  return squares32_bitcast(x.hi);
}

fn squares32_bitcast(u: u32) -> f32 {
  return bitcast<f32>((u >> 9) | 0x3f800000) - 1.0;
}

fn squares32_round(a: U64, b: U64) -> U64 {
  return u64_swp(u64_add(u64_sqr(a), b));
}

fn u64_add(a: U64, b: U64) -> U64 {
  let lo_sum = a.lo + b.lo;
  let carry = u32(lo_sum < a.lo);
  return U64(a.hi + b.hi + carry, lo_sum);
}

fn u64_mul(a: U64, b: U64) -> U64 {
  let hi = u32_mul_hi(a.lo, b.lo);
  return U64(a.hi * b.lo + a.lo * b.hi + hi, a.lo * b.lo);
}

fn u64_sqr(a: U64) -> U64 {
  let hi = u32_mul_hi(a.lo, a.lo);
  return U64(2 * a.hi * a.lo + hi, a.lo * a.lo);
}

fn u64_swp(a: U64) -> U64 {
  return U64(a.lo, a.hi);
}

fn u32_mul_hi(a: u32, b: u32) -> u32 {
  let ah = a >> 16;
  let bh = b >> 16;
  let al = a & 0xffff;
  let bl = b & 0xffff;
  let albl = al * bl;
  let ahbl = ah * bl;
  let albh = al * bh;
  let sum = (ahbl & 0xffff) + (albh & 0xffff) + (albl >> 16);
  return ah * bh + (ahbl >> 16) + (albh >> 16) + (sum >> 16);
}