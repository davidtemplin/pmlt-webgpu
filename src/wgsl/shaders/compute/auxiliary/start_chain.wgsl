@compute
@workgroup_size(1)
fn start_chain() {
    let sum = path.scalar_contribution[r];
    let m = binary_search(0, PATH_COUNT - 1, sum, uniforms.random);
    let large_step_index =  m * numbers_per_path;
    chain.large_step_index_hi[chain_id] = 0;
    chain.large_step_index_lo[chain_id] = large_step_index;
    chain.small_step_count[chain_id] = 1;
    chain.b[chain_id] = sum;
}