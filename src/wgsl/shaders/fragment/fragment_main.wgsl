@fragment
fn fragment_main(input: VertexOutput) -> FragmentOutput {
    let value = read_image(u32(input.position.x), u32(input.position.y)) / f32(image.sample_count);
    let color = gamma_correct(tone_map(value));
    var output: FragmentOutput;
    output.color = color;
    return output;
}