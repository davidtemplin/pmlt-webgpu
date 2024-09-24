fn get_chain_contribution(chain_id: u32) -> vec3f {
    return vec3f(chain.contribution[0][chain_id], chain.contribution[1][chain_id], chain.contribution[2][chain_id]);
}

fn set_chain_contribution(chain_id: u32, c: vec3f) {
    chain.contribution[0][chain_id] = c.r;
    chain.contribution[1][chain_id] = c.g;
    chain.contribution[2][chain_id] = c.b;
}

fn set_chain_large_step_index(chain_id: u32, i: U64) {
    chain.large_step_index_hi[chain_id] = index.hi;
    chain.large_step_index_lo[chain_id] = index.lo;
}

fn compute_large_step_index(chain_id: u32, i: u32) -> U64 {
    let iteration = chain.iteration[chain_id];
    let numbers_per_iteration = chain.numbers_per_iteration[chain_id];
    let path_offset = i * chain.numbers_per_path[chain_id];
    return u64_add(u64_mul(u64_from(iteration), u64_from(numbers_per_iteration)), u64_from(path_offset));
}