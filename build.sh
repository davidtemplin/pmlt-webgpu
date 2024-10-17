LIB=`
cat src/wgsl/lib/constants.wgsl;
echo "\n";
cat src/wgsl/lib/types.wgsl;
echo "\n";
cat src/wgsl/lib/data.wgsl;
echo "\n";
cat src/wgsl/lib/random.wgsl;
echo "\n";
cat src/wgsl/lib/util.wgsl;
echo "\n";
cat src/wgsl/lib/camera.wgsl;
echo "\n";
cat src/wgsl/lib/queue.wgsl;
echo "\n";
cat src/wgsl/lib/image.wgsl;
echo "\n";
cat src/wgsl/lib/chain.wgsl;
echo "\n";
cat src/wgsl/lib/scene.wgsl;
echo "\n";
cat src/wgsl/lib/light.wgsl;
echo "\n";
cat src/wgsl/lib/material.wgsl;
echo "\n";
cat src/wgsl/lib/path.wgsl;
echo "\n";
cat src/wgsl/lib/path_log.wgsl;
echo "\n";
`

JS=`
cat src/js/keys.js;
echo "\n";
cat src/js/key_util.js;
echo "\n";
cat src/js/config.js;
echo "\n";
cat src/js/code.js;
echo "\n";
cat src/js/buffers/camera.js;
echo "\n";
cat src/js/buffers/chain.js;
echo "\n";
cat src/js/buffers/dispatch_indirect_parameters.js;
echo "\n";
cat src/js/buffers/image.js;
echo "\n";
cat src/js/buffers/path.js;
echo "\n";
cat src/js/buffers/queue.js;
echo "\n";
cat src/js/buffers/scene.js;
echo "\n";
cat src/js/buffers/path_log.js;
echo "\n";
cat src/js/kernels/initialize.js;
echo "\n";
cat src/js/kernels/sample_camera.js;
echo "\n";
cat src/js/kernels/sample_light.js;
echo "\n";
cat src/js/kernels/clear_queue.js;
echo "\n";
cat src/js/kernels/dispatch.js;
echo "\n";
cat src/js/kernels/intersect.js;
echo "\n";
cat src/js/kernels/connect.js;
echo "\n";
cat src/js/kernels/post_connect_null.js;
echo "\n";
cat src/js/kernels/post_connect_camera_direct.js;
echo "\n";
cat src/js/kernels/post_connect_camera_indirect.js;
echo "\n";
cat src/js/kernels/post_connect_light_direct.js;
echo "\n";
cat src/js/kernels/post_connect_light_indirect.js;
echo "\n";
cat src/js/kernels/contribute.js;
echo "\n";
cat src/js/kernels/sample_material.js;
echo "\n";
cat src/js/kernels/build_cdf.js;
echo "\n";
cat src/js/kernels/start_chain.js;
echo "\n";
cat src/js/kernels/build_pdf.js;
echo "\n";
cat src/js/kernels/distribute.js;
echo "\n";
cat src/js/kernels/update_chain.js;
echo "\n";
cat src/js/kernels/restart.js;
echo "\n";
cat src/js/kernels/render.js;
echo "\n";
cat src/js/data.js;
echo "\n";
cat src/js/debug.js;
echo "\n";
cat src/js/executor.js;
echo "\n";
cat src/js/scene.js;
echo "\n";
cat src/js/timestamp.js;
echo "\n";
cat src/js/vector_math.js;
echo "\n";
cat src/js/main.js;
echo "\n";
`

JS="$(echo "$JS" | sed -e "s/#include lib.wgsl/\n$(echo "$LIB" | sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include initialize.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/initialize.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include dispatch.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/dispatch.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include clear_queue.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/clear_queue.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include sample_camera.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/sample_camera.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include sample_light.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/sample_light.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include intersect.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/intersect.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include build_cdf.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/build_cdf.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_camera_direct.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/post_connect_camera_direct.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_camera_indirect.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/post_connect_camera_indirect.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_light_direct.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/post_connect_light_direct.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_light_indirect.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/post_connect_light_indirect.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_null.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/post_connect_null.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include build_pdf.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/build_pdf.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include distribute.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/distribute.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include restart.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/restart.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include start_chain.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/start_chain.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include update_chain.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/auxiliary/update_chain.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include sample_material.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/sample_material.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include contribute.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/contribute.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include connect.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/compute/primary/connect.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include vertex.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/vertex/vertex_main.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include fragment.wgsl/\n\${WGSL_LIB_CODE}\n\n$(cat src/wgsl/shaders/fragment/fragment_main.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"


HTML="$(cat src/html/main.html | sed -e "s/<!-- #include main.js -->/$(echo "$JS" | sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"

echo "$HTML" > build/main.html