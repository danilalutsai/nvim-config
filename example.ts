// Colorscheme palette sampler — every common TS token kind in one file.
/** JSDoc block: {@link Repo} keeps generics + docs highlighting visible. */

import { readFile } from "node:fs/promises";

export const MAX_RETRIES = 3;
const TAG = `retry:${MAX_RETRIES}`;

export enum Level {
  Debug = 0,
  Warn = 1,
  Error = 2,
}

export type Id = string | number;

export interface User {
  readonly id: Id;
  name: string;
  level?: Level;
  meta: Record<string, unknown>;
}

type Partialize<T> = { [K in keyof T]?: T[K] };

export abstract class Repo<T extends { id: Id }> {
  protected items = new Map<Id, T>();
  static instances = 0;

  constructor(private readonly label: string) {
    Repo.instances++;
  }

  abstract validate(item: Partialize<T>): boolean;

  get size(): number {
    return this.items.size;
  }

  add(item: T): this {
    if (!this.validate(item)) throw new Error(`${this.label}: invalid item`);
    this.items.set(item.id, item);
    return this;
  }
}

class UserRepo extends Repo<User> {
  validate(item: Partialize<User>): boolean {
    return typeof item.name === "string" && item.name.length > 0;
  }
}

export async function load(path: string): Promise<User[]> {
  for (let i = 0; i < MAX_RETRIES; i++) {
    try {
      const raw = await readFile(path, "utf8");
      return JSON.parse(raw) as User[];
    } catch (err) {
      if (i === MAX_RETRIES - 1) throw err;
    }
  }
  return [];
}

const describe = (u: User): string => {
  switch (u.level ?? Level.Debug) {
    case Level.Error:
      return `${u.name} !!`;
    case Level.Warn:
      return `${u.name} ?`;
    default:
      return u.name;
  }
};

const repo = new UserRepo(TAG);
repo.add({ id: 1, name: "ada", meta: { admin: true } });
console.log(describe({ id: 1, name: "ada", meta: {} }), repo.size, /\d+/.test(TAG));
