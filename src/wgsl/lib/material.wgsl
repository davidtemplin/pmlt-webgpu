fn sample_material(material_id: u32, p: vec3f, wo: vec3f, n: vec3f, u: vec2f) -> MaterialSample {
    return sample_matte_material(material_id, wo, n, u);
}

fn evaluate_material(material_id: u32, wo: vec3f, n: vec3f, wi: vec3f) -> MaterialEvaluation {
    return evaluate_matte_material(material_id, wo, n, wi);
}

fn sample_matte_material(material_id: u32, wo: vec3f, n: vec3f, u: vec2f) -> MaterialSample {
    let wi = cosine_sample_hemisphere(n, u[0], u[1]);
    let pdf_fwd = matte_material_directional_pdf(wo, n, wi);
    let pdf_rev = matte_material_directional_pdf(wi, n, wo);
    let throughput = get_sphere_color(material_id) / PI;
    let valid = same_hemisphere(n, wo, wi);
    return MaterialSample(wi, pdf_fwd, pdf_rev, throughput, valid);
}

fn evaluate_matte_material(material_id: u32, wo: vec3f, n: vec3f, wi: vec3f) -> MaterialEvaluation {
    let pdf_fwd = matte_material_directional_pdf(wo, n, wi);
    let pdf_rev = matte_material_directional_pdf(wi, n, wo);
    let throughput = get_sphere_color(material_id) * matte_material_reflectance(wo, n, wi);
    let valid = same_hemisphere(n, wo, wi);
    return MaterialEvaluation(pdf_fwd, pdf_rev, throughput, valid);
}

fn matte_material_reflectance(wo: vec3f, n: vec3f, wi: vec3f) -> f32 {
    return 1.0 / PI;
}

fn matte_material_directional_pdf(wo: vec3f, n: vec3f, wi: vec3f) -> f32 {
    let h = f32(same_hemisphere(n, wo, wi));
    return h * abs_cos_theta(n, wi) / PI;
}