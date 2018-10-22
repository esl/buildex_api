export default class NewTaskForm {
  handleDOMContentLoaded () {
    const btnAddCommand = document.getElementById('add-command')
    if (btnAddCommand) {
      btnAddCommand.addEventListener('click', this.onAddCommand, false)
    }
  }

  onAddCommand (event) {
    event.preventDefault()

    const commandGroup = document.querySelector('[data-commands-group]')
    const input = document.createElement('input')
    input.className = 'form-control'
    input.name = 'task[commands][]'
    input.type = 'text'
    commandGroup.appendChild(input)
  }
}

const form = new NewTaskForm()

window.addEventListener('DOMContentLoaded', form.handleDOMContentLoaded.bind(form), false)
