import Variable from "astal/variable"

const colors = ['#FF5555', '#F1FA8C', '#50FA7B', '#8BE9FD', '#BD93F9'];
export const currentColor = Variable(colors[0]);

let i = 0;
setInterval(() => {
    i = (i + 1) % colors.length;
    currentColor.set(colors[i]);
}, 1000);

