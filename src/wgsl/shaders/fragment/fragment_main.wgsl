@fragment
fn fragment_main(input: VertexOutput) -> FragmentOutput {
    // convert coordinates to image pixel coordinates x,y
    let color = read_image(x, y);
    return color;
}