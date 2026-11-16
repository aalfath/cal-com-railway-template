# Cal.com v6.2.0, the latest official release and image (2026-03-01).
# Pinned by version and digest; bump both together and add a CHANGELOG entry.
FROM calcom/cal.com:v6.2.0@sha256:ace3bb1219fb7306585ab9f4d94d41af7ee064c343db0498173436bbe857bd49

COPY railway-start.sh /calcom/scripts/railway-start.sh
RUN chmod 755 /calcom/scripts/railway-start.sh

EXPOSE 3000
CMD ["/calcom/scripts/railway-start.sh"]
