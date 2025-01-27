// filepath: /Users/erindhoxha/Documents/prjcts/store/app/assets/javascripts/application.js
//= require rails-ujs
//= require turbolinks
//= require_tree .

document.addEventListener("DOMContentLoaded", () => {
  console.log("AAAA");
  const confirmationModal = document.getElementById("exampleModal");
  const confirmDeleteButton = document.getElementById("confirmDelete");

  confirmationModal.addEventListener("show.bs.modal", (event) => {
    const button = event.relatedTarget;
    const articleId = button.getAttribute("data-article-id");
    confirmDeleteButton.setAttribute("data-article-id", articleId);
  });

  confirmDeleteButton.addEventListener("click", () => {
    const articleId = confirmDeleteButton.getAttribute("data-article-id");
    const form = document.createElement("form");
    form.method = "POST";
    form.action = `/articles/${articleId}`;
    form.innerHTML = `<input name="_method" value="delete" type="hidden"><input name="authenticity_token" value="${
      document.querySelector('meta[name="csrf-token"]').content
    }" type="hidden">`;
    document.body.appendChild(form);
    form.submit();
  });
});
