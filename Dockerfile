FROM swift:3.1
ADD . /tejlor
WORKDIR /tejlor
RUN swift build --configuration release
ENTRYPOINT [".build/release/Taylor"]
