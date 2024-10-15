@compute
@workgroup_size(1)
fn build_pdf() {
    var sum: f32 = 0.0;
    for (var i: u32 = 0; i < CHAIN_COUNT; i++) {
        sum += chain.b[i];
    }

    for (var i: u32 = 0; i < CHAIN_COUNT; i++) {
        chain.pdf[i] = chain.b[i] / sum;
    }

    // Compute the bounds of each chain
    sum = 0.0;
    var min_path_index: u32 = 0;
    for(var i: u32 = 0; i < CHAIN_COUNT; i++) {
        sum += chain.pdf[i];
        let max_path_index = u32(round(sum * f32(PATH_COUNT)));
        chain.min_path_index[i] = min_path_index;
        chain.max_path_index[i] = max_path_index;
        let path_count = max_path_index - min_path_index + 1;
        chain.path_count[i] = path_count;
        chain.min_small_step_index[i] = min_path_index;
        chain.max_small_step_index[i] = min_path_index + u32(round(SMALL_STEP_PROBABILITY * f32(path_count)));
        min_path_index = max_path_index + 1;
    }
}