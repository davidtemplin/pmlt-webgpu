const config = new Config();

const WGSL_LIB_CODE = `#include lib.wgsl`;

const INITIALIZE_CODE = `#include initialize.wgsl`;
const SAMPLE_CAMERA_CODE = `#include sample_camera.wgsl`;
const SAMPLE_LIGHT_CODE = `#include sample_light.wgsl`;
const CLEAR_QUEUE_CODE = `#include clear_queue.wgsl`;
const DISPATCH_CODE = `#include dispatch.wgsl`;
const INTERSECT_CODE = `#include intersect.wgsl`;