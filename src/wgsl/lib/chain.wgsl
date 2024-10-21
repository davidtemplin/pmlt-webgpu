fn get_chain_contribution(chain_id: u32) -> vec3f {
    return vec3f(chain.contribution[0][chain_id], chain.contribution[1][chain_id], chain.contribution[2][chain_id]);
}

fn set_chain_contribution(chain_id: u32, c: vec3f) {
    chain.contribution[0][chain_id] = c.r;
    chain.contribution[1][chain_id] = c.g;
    chain.contribution[2][chain_id] = c.b;
}

fn set_chain_large_step_index(chain_id: u32, index: U64) {
    chain.large_step_index[HI][chain_id] = index.hi;
    chain.large_step_index[LO][chain_id] = index.lo;
}

fn set_chain_pixel(chain_id: u32, pixel: vec2u) {
    chain.pixel[0][chain_id] = pixel.x;
    chain.pixel[1][chain_id] = pixel.y;
}

fn get_chain_pixel(chain_id: u32) -> vec2u {
    return vec2u(chain.pixel[0][chain_id], chain.pixel[1][chain_id]);
}

fn compute_large_step_index(chain_id: u32, i: u32) -> U64 {
    let iteration = chain.iteration[chain_id];
    let numbers_per_iteration = chain.numbers_per_iteration[chain_id];
    let path_offset = i * chain.numbers_per_path[chain_id];
    return u64_add(u64_mul(u64_from(iteration), u64_from(numbers_per_iteration)), u64_from(path_offset));
}

fn get_current_contribution_weight(chain_id: u32, a: f32) -> f32 {
    let path_length = chain_id + MIN_PATH_LENGTH;
    let pdf = chain.pdf[chain_id];
    let sc = chain.scalar_contribution[chain_id];
    let b = chain.b[chain_id];
    return ((f32(path_length) / pdf) * a) / ((sc / b) + LARGE_STEP_PROBABILITY);
}

fn get_proposal_contribution_weight(chain_id: u32, a: f32, sc: f32, step_type: u32) -> f32 {
    let step_term = f32(step_type == LARGE_STEP);
    let b = chain.b[chain_id];
    let pdf = chain.pdf[chain_id];
    let path_length = chain_id + MIN_PATH_LENGTH;
    return ((f32(path_length) / pdf) * (a + step_term)) / ((sc / b) + LARGE_STEP_PROBABILITY);
}