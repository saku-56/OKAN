class PwaController < ApplicationController
  # manifest.json を返す
  def manifest
    render template: "pwa/manifest", formats: [ :json ], content_type: "application/json"
  end

  # service-worker.js を返す
  def service_worker
    render template: "pwa/service-worker", formats: [ :js ]
  end
end
