fn sample_material(material_id: u32, p: vec3f, wo: vec3f, n: vec3f, u: vec2f) -> MaterialSample {
    return sample_matte_material(material_id, wo, n, u);
}

fn evaluate_material(material_id: u32, wo: vec3f, n: vec3f, wi: vec3f) -> MaterialEvaluation {
    let pdf = abs_cos_theta(n, wi) / PI;
    let throughput = get_sphere_color(material_id);
    return MaterialEvaluation(pdf, pdf, throughput, true);
}

fn sample_matte_material(material_id: u32, _wo: vec3f, n: vec3f, u: vec2f) -> MaterialSample {
    let wi = cosine_sample_hemisphere(n, u[0], u[1]);
    let pdf = abs_cos_theta(n, wi) / PI;
    let throughput = get_sphere_color(material_id);
    return MaterialSample(wi, pdf, pdf, throughput / PI, true);
}

fn matte_material_reflectance(wo: vec3f, n: vec3f, wi: vec3f) -> f32 {
    return 1.0 / PI;
}

fn matte_material_directional_pdf(wo: vec3f, n: vec3f, wi: vec3f) -> f32 {
    let h = f32(same_hemisphere(n, wo, wi)) ;
    return h * abs_cos_theta(n, wi) / PI;
}