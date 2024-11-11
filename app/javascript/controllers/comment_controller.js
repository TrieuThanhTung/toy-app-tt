import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {
  static targets = ["replyButton", "replyForm", "replies", "repliesButton", "textarea"]
  connect() {
    this.formTarget.addEventListener("turbo:submit-end", this.clearTextarea.bind(this));
  }

  disconnect() {
    this.formTarget.removeEventListener("turbo:submit-end", this.clearTextarea.bind(this));
  }

  reply_toggle = () => {
    const replyForm = this.replyFormTarget
    if (replyForm.style.display === 'none') {
      replyForm.style.display = "block"
    } else {
      replyForm.style.display = "none"
    }
  }

  show_replies = () => {
    const replies = this.repliesTarget
    const repliesButton = this.repliesButtonTarget
    if (replies.style.display === 'block') {
      replies.style.display = "none"
      repliesButton.innerHTML = repliesButton.innerHTML.replace("Hide", "Show")
    } else {
      replies.style.display = "block"
      repliesButton.innerHTML = repliesButton.innerHTML.replace("Show", "Hide");
    }
  }

  clearTextarea(event) {
    if (event.detail.success) {
      this.textareaTarget.value = '';
    }
  }
}
