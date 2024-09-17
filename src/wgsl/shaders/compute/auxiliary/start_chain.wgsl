@compute
@workgroup_size(1)
fn start_chain() {
    var l: u32 = 0;
    var r: u32 = PATH_COUNT - 1;
    let sum = path_state.scalar_contribution[r];
    var m: u32 = 0;
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
    let large_step_index =  m * numbers_per_path;
    chain.large_step_index_hi[chain_id] = 0;
    chain.large_step_index_lo[chain_id] = large_step_index;
    chain.small_step_count[chain_id] = 1;
    chain.b[chain_id] = sum;
}