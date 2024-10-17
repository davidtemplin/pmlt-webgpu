@compute
@workgroup_size(1)
fn enable_image_main() {
    image.write_mode = ENABLED;
}