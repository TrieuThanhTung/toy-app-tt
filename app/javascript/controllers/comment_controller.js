import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {
  static targets = ["replyButton", "replyForm", "replies", "repliesButton"]
  connect() {
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
}
