FROM dlanguage/ldc:1.8.0

ARG LDC_VERSION=1.8.0

RUN apt update && apt install p7zip curl xz-utils -y

RUN curl -L -o ldc2-windows.7z "https://github.com/ldc-developers/ldc/releases/download/v${LDC_VERSION}/ldc2-${LDC_VERSION}-windows-x64.7z"
RUN 7zr x ldc2-windows.7z
RUN cp ldc2-"${LDC_VERSION}"-windows-x64/lib/*.lib "/dlang/ldc-${LDC_VERSION}/lib"
RUN sed -i -e 's/        "-L--no-warn-search-mismatch",/        "-mtriple=x86_64-pc-windows-msvc",\n        "-link-internally",/g' "/dlang/ldc-${LDC_VERSION}/etc/ldc2.conf"

RUN curl -L -o libs_msvc.tar.xz 'https://dl.dropboxusercontent.com/s/6js68fbccj9b0m5/libs_msvc14_x64.tar.xz?dl=0'
RUN mkdir libs_msvc && tar xf libs_msvc.tar.xz -C libs_msvc
RUN cd libs_msvc && cp \
  advapi32.lib \
  comdlg32.lib \
  gdi32.lib \
  kernel32.lib \
  legacy_stdio_definitions.lib \
  legacy_stdio_wide_specifiers.lib \
  libcmt.lib \
  libucrt.lib \
  libvcruntime.lib \
  oldnames.lib \
  ole32.lib \
  oleaut32.lib \
  shell32.lib \
  user32.lib \
  uuid.lib \
  winspool.lib \
  ws2_32.lib \
  wsock32.lib \
  /dlang/ldc-${LDC_VERSION}/lib && \
  ln -s "/dlang/ldc-${LDC_VERSION}/lib/oldnames.lib" "/dlang/ldc-${LDC_VERSION}/lib/OLDNAMES.lib"

RUN rm -rf \
  "ldc2-${LDC_VERSION}-windows-x64" \
  ldc2-windows.7z \
  libs_msvc \
  libs_msvc.tar.xz \
  /var/lib/apt/lists/*

ENTRYPOINT /bin/bash
