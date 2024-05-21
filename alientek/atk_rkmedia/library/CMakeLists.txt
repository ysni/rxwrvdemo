include_directories(.)
include_directories(include)
include_directories(ssd)
include_directories(rknn_queue)

set (OPENCV_LIBS opencv_core opencv_imgcodecs opencv_imgproc opencv_features2d opencv_flann opencv_highgui)
aux_source_directory(common COMMON_SRC)

set(COMMON_ISP_LIBRARY_NAME sample_common_isp)
set(COMMON_ISP_LIBRARY_VERSION 1.0.1)
add_library(${COMMON_ISP_LIBRARY_NAME} SHARED ${COMMON_SRC})
set_target_properties(${COMMON_ISP_LIBRARY_NAME} PROPERTIES VERSION ${COMMON_ISP_LIBRARY_VERSION})
set_target_properties(${COMMON_ISP_LIBRARY_NAME} PROPERTIES SOVERSION 1)
install(TARGETS ${COMMON_ISP_LIBRARY_NAME}
        LIBRARY DESTINATION "lib")

configure_file("libsample_common_isp.pc.cmake" "libsample_common_isp.pc" @ONLY)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/libsample_common_isp.pc"
        DESTINATION "lib/pkgconfig/")

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/common/sample_common.h
       DESTINATION "include/easymedia")

set(ATK_FACE_DETECTION_LIBRARY_NAME atk_face_detection)
set(ATK_FACE_DETECTION_VERSION 1.0.0)
add_library(${ATK_FACE_DETECTION_LIBRARY_NAME} SHARED atk_face_detection.cpp ${COMMON_SRC})
target_link_libraries(${ATK_FACE_DETECTION_LIBRARY_NAME} pthread easymedia rga rkaiq rknn_api sample_common_isp ${OPENCV_LIBS})
set_target_properties(${ATK_FACE_DETECTION_LIBRARY_NAME} PROPERTIES VERSION ${ATK_FACE_DETECTION_VERSION})
set_target_properties(${ATK_FACE_DETECTION_LIBRARY_NAME} PROPERTIES SOVERSION 1)
install(TARGETS ${ATK_FACE_DETECTION_LIBRARY_NAME}
        LIBRARY DESTINATION "lib")

configure_file("libatkfacedetection.pc.cmake" "libatkfacedetection.pc" @ONLY)
install(FILES "libatkfacedetection.pc"
        DESTINATION "lib/pkgconfig/")


set(ATK_CAMERA_LIBRARY_NAME atk_camera)
set(ATK_CAMERA 1.0.0)
add_library(${ATK_CAMERA_LIBRARY_NAME} SHARED atk_camera ${COMMON_SRC})
set_target_properties(${ATK_CAMERA_LIBRARY_NAME} PROPERTIES VERSION ${ATK_CAMERA})
set_target_properties(${ATK_CAMERA_LIBRARY_NAME} PROPERTIES SOVERSION 1)
install(TARGETS ${ATK_CAMERA_LIBRARY_NAME}
        LIBRARY DESTINATION "lib")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/
       DESTINATION "include/alientek")

configure_file("libatkcamera.pc.cmake" "libatkcamera.pc" @ONLY)
install(FILES "libatkcamera.pc"
        DESTINATION "lib/pkgconfig/")

set(ATK_AI_LIBRARY_NAME atk_ai)
set(ATK_AI 1.0.0)
add_library(${ATK_AI_LIBRARY_NAME} SHARED atk_ai ${COMMON_SRC})
set_target_properties(${ATK_AI_LIBRARY_NAME} PROPERTIES VERSION ${ATK_AI})
set_target_properties(${ATK_AI_LIBRARY_NAME} PROPERTIES SOVERSION 1)
install(TARGETS ${ATK_AI_LIBRARY_NAME}
        LIBRARY DESTINATION "lib")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/
       DESTINATION "include/alientek")

configure_file("libatkai.pc.cmake" "libatkai.pc" @ONLY)
install(FILES "libatkai.pc"
        DESTINATION "lib/pkgconfig/")

set(ATK_VDEC_LIBRARY_NAME atk_vdec)
set(ATK_VDEC 1.0.0)
add_library(${ATK_VDEC_LIBRARY_NAME} SHARED atk_vdec ${COMMON_SRC})
set_target_properties(${ATK_VDEC_LIBRARY_NAME} PROPERTIES VERSION ${ATK_VDEC})
set_target_properties(${ATK_VDEC_LIBRARY_NAME} PROPERTIES SOVERSION 1)
install(TARGETS ${ATK_VDEC_LIBRARY_NAME}
        LIBRARY DESTINATION "lib")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/
       DESTINATION "include/alientek")

configure_file("libatkvdec.pc.cmake" "libatkvdec.pc" @ONLY)
install(FILES "libatkvdec.pc"
        DESTINATION "lib/pkgconfig/")

set(ATK_VENC_LIBRARY_NAME atk_venc)
set(ATK_VENC 1.0.0)
add_library(${ATK_VENC_LIBRARY_NAME} SHARED atk_venc ${COMMON_SRC})
set_target_properties(${ATK_VENC_LIBRARY_NAME} PROPERTIES VERSION ${ATK_VENC})
set_target_properties(${ATK_VENC_LIBRARY_NAME} PROPERTIES SOVERSION 1)
install(TARGETS ${ATK_VENC_LIBRARY_NAME}
        LIBRARY DESTINATION "lib")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/
       DESTINATION "include/alientek")

configure_file("libatkvenc.pc.cmake" "libatkvenc.pc" @ONLY)
install(FILES "libatkvenc.pc"
        DESTINATION "lib/pkgconfig/")

set(ATK_SSD_OBJECT_RECOGNITION_LIBRARY_NAME atk_ssd_object_recognition)
set(ATK_SSD_OBJECT_RECOGNITION_VERSION 1.0.0)
add_library(${ATK_SSD_OBJECT_RECOGNITION_LIBRARY_NAME} SHARED atk_ssd_object_recognition.cpp ssd/ssd.cc ${COMMON_SRC})
target_link_libraries(${ATK_SSD_OBJECT_RECOGNITION_LIBRARY_NAME} pthread easymedia rga rkaiq rknn_api sample_common_isp ${OPENCV_LIBS})
set_target_properties(${ATK_SSD_OBJECT_RECOGNITION_LIBRARY_NAME} PROPERTIES VERSION ${ATK_SSD_OBJECT_RECOGNITION_VERSION})
set_target_properties(${ATK_SSD_OBJECT_RECOGNITION_LIBRARY_NAME} PROPERTIES SOVERSION 1)
install(TARGETS ${ATK_SSD_OBJECT_RECOGNITION_LIBRARY_NAME}
        LIBRARY DESTINATION "lib")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/
       DESTINATION "include/alientek")

configure_file("libatkssdobjectrecognition.pc.cmake" "libatkssdobjectrecognition.pc" @ONLY)
install(FILES "libatkssdobjectrecognition.pc"
        DESTINATION "lib/pkgconfig/")
