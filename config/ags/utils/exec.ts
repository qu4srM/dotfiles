import { execAsync } from "astal/process"


export function safeExecAsync(cmd: string[]) {
    return execAsync(cmd).catch(err => {
        console.error(err)
        return ""  // para evitar errores si usas .trim() después
    })
}