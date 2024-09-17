@compute
@workgroup_size(1)
fn update_chain() {
    let c = vec3f(chain.contribution_r[uniforms.chain_id], chain.contribution_g[uniforms.chain_id], chain.contribution_b[uniforms.chain_id]);
    let path_length = uniforms.chain_id + MIN_PATH_LENGTH;
    let path_length_pdf = chain.path_length_pdf[uniforms.chain_id];
    let step_type = chain.step_type[uniforms.chain_id];
    let step_term = f32(step_type == LARGE_STEP);
    let sc = chain.scalar_contribution[uniforms.chain_id];
    let min_path_index = chain.min_path_index[uniforms.chain_id];
    let path_count = chain.path_count[uniforms.chain_id];
    let final_index = min_path_index + path_count;
    let a = 1.0 - path_state.scalar_contribution[final_index];
    let b = chain.b[chain_id];
    let weight = ((f32(path_length) / path_length_pdf) * (a + step_term)) / ((sc / b) + LARGE_STEP_PROBABILITY);
    contribute(c * weight, x, y);

    var l: u32 = min_path_index;
    var r: u32 = min_path_index + path_count - 1;
    var m: u32 = 0;
    let sum = path_state.scalar_contribution[r] + chain.scalar_contribution[chain_id];

    if uniforms.random <= path_state.scalar_contribution[r] {
        while l <= r {
            m = (l + r) / 2;
            let v = path_state.scalar_contribution[m] / sum;
            if uniforms.random <= path_state.scalar_contribution[m] {
                if uniforms.random > path_state.scalar_contribution[m - 1] {
                    break;
                }
                r = m - 1;
            } else {
                l = m + 1;
            }
        }

        chain.scalar_contribution[chain_id] = path_state.scalar_contribution[m];
        chain.contribution_r[chain_id] = path_state.contribution_r[m];
        chain.contribution_g[chain_id] = path_state.contribution_g[m];
        chain.contribution_b[chain_id] = path_state.contribution_b[m];
        if step_type == LARGE_STEP {
            let iteration = chain.iteration[chain_id];
            let numbers_per_iteration = chain.numbers_per_iteration[chain_id];
            let path_offset = m * chain.numbers_per_path[chain_id];
            let index = u64_add(u64_mul(u64_from(iteration), u64_from(numbers_per_iteration)), u64_from(path_offset));
            chain.large_step_index_hi[chain_id] = index.hi;
            chain.large_step_index_lo[chain_id] = index.lo;
            chain.small_step_count[chain_id] = 1;
        } else {
            chain.small_step_count[chain_id] = chain.small_step_count[chain_id] + 1;
        }
    }
    
    chain.iteration[chain_id] = chain.iteration[chain_id] + 1;
}