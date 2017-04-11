FROM swift:3.1
ADD . /tejlor
WORKDIR /tejlor
RUN swift build --configuration release
CMD [".build/release/Taylor"]
