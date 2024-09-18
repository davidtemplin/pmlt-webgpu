@compute
@workgroup_size(1)
fn build_pdf() {
    var sum: f32 = 0.0;
    for var i: u32 = 0; i < CHAIN_COUNT; i++ {
        sum += chain.b[i];
    }
    for var i: u32 = 0; i < CHAIN_COUNT; i++ {
        chain.path_length_pdf[i] = chain.b[i] / sum;
    }
    // TODO: update other chain properties
}