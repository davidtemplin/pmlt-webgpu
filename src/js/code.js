const config = new Config();

const WGSL_LIB_CODE = `#include lib.wgsl`;

const INITIALIZE_CODE = `#include initialize.wgsl`;
const SAMPLE_CAMERA_CODE = `#include sample_camera.wgsl`;
const SAMPLE_LIGHT_CODE = `#include sample_light.wgsl`;
const CLEAR_QUEUE_CODE = `#include clear_queue.wgsl`;
const DISPATCH_CODE = `#include dispatch.wgsl`;
const INTERSECT_CODE = `#include intersect.wgsl`;
const CONNECT_CODE = `#include connect.wgsl`;
const POST_CONNECT_NULL_CODE = `#include post_connect_null.wgsl`;
const POST_CONNECT_CAMERA_DIRECT_CODE = `#include post_connect_camera_direct.wgsl`;
const POST_CONNECT_CAMERA_INDIRECT_CODE = `#include post_connect_camera_indirect.wgsl`;
const POST_CONNECT_LIGHT_DIRECT_CODE = `#include post_connect_light_direct.wgsl`;
const POST_CONNECT_LIGHT_INDIRECT_CODE = `#include post_connect_light_indirect.wgsl`;
const CONTRIBUTE_CODE = `#include contribute.wgsl`;
const SAMPLE_MATERIAL_CODE = `#include sample_material.wgsl`;
const BUILD_CDF_CODE = `#include build_cdf.wgsl`;
const START_CHAIN_CODE = `#include start_chain.wgsl`;
const BUILD_PDF_CODE = `#include build_pdf.wgsl`;
const DISTRIBUTE_CODE = `#include distribute.wgsl`;
const VERTEX_CODE = `#include vertex.wgsl`;
const FRAGMENT_CODE = `#include fragment.wgsl`;
const UPDATE_CHAIN_CODE = `#include update_chain.wgsl`;
const RESTART_CODE = `#include restart.wgsl`;
const ENABLE_IMAGE_CODE = `#include enable_image.wgsl`;