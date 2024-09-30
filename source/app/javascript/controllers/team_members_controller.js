import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchInput", "searchResults", "addMemberButton", "teamMembersList"];

  connect() {
    this.teamId = this.element.dataset.teamId;
    console.log("TeamMembersController connected with teamId:", this.teamId); // Debugging line
  }

  search() {
    const query = this.searchInputTarget.value;
    console.log("Searching for:", query); // Debugging line
    fetch(`/teams/${this.teamId}/search_members?query=${query}`)
      .then(response => response.json())
      .then(data => {
        console.log("Search results:", data); // Debugging line
        this.searchResultsTarget.innerHTML = '';
        data.forEach(user => {
          const option = document.createElement('option');
          option.value = user.id;
          option.textContent = `${user.first_name} ${user.last_name}`;
          this.searchResultsTarget.appendChild(option);
        });
        this.addMemberButtonTarget.disabled = data.length === 0; // Disable button if no results
      })
      .catch(error => console.error("Error fetching search results:", error)); // Error handling
  }

  addMember() {
    const userId = this.searchResultsTarget.value;
    console.log("Adding member with userId:", userId); // Debugging line
    fetch(`/teams/${this.teamId}/add_member`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ user_id: userId })
    })
      .then(response => {
        if (!response.ok) {
          return response.json().then(data => {
            alert(data.message || 'An error occurred while adding the member.'); // Alert error message
          });
        }
        return response.json(); // Process successful response
      })
      .then(data => {
        console.log("Updated team members:", data); // Debugging line
        // Update the team members list
        this.teamMembersListTarget.innerHTML = '';
        data.forEach(member => {
          const listItem = document.createElement('li');
          listItem.textContent = `${member.first_name} ${member.last_name}`;
          const removeButton = document.createElement('button');
          removeButton.textContent = 'Remove';
          removeButton.dataset.userId = member.id;
          removeButton.dataset.action = 'team-members#removeMember';
          listItem.appendChild(removeButton);
          this.teamMembersListTarget.appendChild(listItem);
        });
      })
      .catch(error => console.error("Error adding member:", error)); // Error handling
  }

  removeMember(event) {
    const userId = event.target.dataset.userId;
    console.log("Removing member with userId:", userId); // Debugging line
    fetch(`/teams/${this.teamId}/remove_member`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ user_id: userId })
    })
      .then(response => response.json())
      .then(data => {
        console.log("Updated team members after removal:", data); // Debugging line
        // Remove the member from the list
        event.target.parentElement.remove();
      })
      .catch(error => console.error("Error removing member:", error)); // Error handling
  }

  showAddMemberSection() {
    document.getElementById('add-member-section').style.display = 'block';
    document.getElementById('show-add-member-section').style.display = 'none';
  }
}
