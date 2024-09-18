@compute
@workgroup_size(WORKGROUP_SIZE)
fn distribute(@builtin(global_invocation_id) id: vec3u) {
    let global_path_index = id.x;
    if global_path_index >= PATH_COUNT {
        return;
    }
    var chain_id: u32 = 0;
    var sum: f32 = 0.0;
    for(var i: u32 = 0; i < CHAIN_COUNT; i++) {
        sum += chain.path_length_pdf[i];
        let max_path_index = u32(sum * f32(PATH_COUNT));
        let m = u32(global_path_index < max_path_index);
        chain_id += m * i;
    }
    path_state.path_length[global_invocation_index] = chain_id + MIN_PATH_LENGTH;
}