fn rand(chain_id: u32, global_path_index: u32, number_offset: u32) -> f32 {
    let path_offset = path.index[global_path_index] * chain.numbers_per_path[chain_id];
    let index = u64_add(u64_mul(u64_from(chain.iteration[chain_id]), u64_from(chain.numbers_per_iteration[chain_id])), u64_from(path_offset + chain.offset[chain_id] + number_offset));
    let random_number = squares32(index, U64(chain.key[HI][chain_id], chain.key[LO][chain_id]));
    if  path.step_type[global_path_index] == LARGE_STEP {
        return random_number;
    } else {
        let value = chain.numbers[number_offset][chain_id];
        let perturbation = SIGMA
          * sqrt(2.0) 
          * erf_inv(2.0 * random_number - 1.0);
        let result = value + perturbation;
        return result - floor(result);
    }
}

fn populate_random_numbers(chain_id: u32, global_path_index: u32) {
  for (var i: u32 = 0; i < chain.numbers_per_path[chain_id]; i++) {
    chain.numbers[i][chain_id] = rand(chain_id, global_path_index, i);
  }
}

fn get_vertex_index(global_path_index: u32, stream_index: u32) -> u32 {
  let technique = get_technique(global_path_index);
  let path_vertex_index = path.vertex_index[global_path_index];
  let vertex_index: u32 = 0;
  choose_u32(stream_index == CAMERA_STREAM_INDEX, path_vertex_index, vertex_index);
  choose_u32(stream_index == LIGHT_STREAM_INDEX, path_vertex_index - technique.camera, vertex_index);
  return vertex_index;
}

fn rand_1(global_path_index: u32, stream_index: u32) -> f32 {
  let chain_id = path.length[global_path_index] - MIN_PATH_LENGTH;
  return rand(chain_id, global_path_index, stream_index * chain.numbers_per_stream[chain_id]);
}

fn rand_2(global_path_index: u32, stream_index: u32) -> vec2f {
  let chain_id = path.length[global_path_index] - MIN_PATH_LENGTH;
  let i = stream_index * chain.numbers_per_stream[chain_id];
  let r1 = rand(chain_id, global_path_index, i);
  let r2 = rand(chain_id, global_path_index, i + 1);
  return vec2f(r1, r2);
}

fn rand_4(global_path_index: u32, stream_index: u32) -> vec4f {
  let chain_id = path.length[global_path_index] - MIN_PATH_LENGTH;
  let i = stream_index * chain.numbers_per_stream[chain_id];
  let r1 = rand(chain_id, global_path_index, i);
  let r2 = rand(chain_id, global_path_index, i + 1);
  let r3 = rand(chain_id, global_path_index, i + 2);
  let r4 = rand(chain_id, global_path_index, i + 3);
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