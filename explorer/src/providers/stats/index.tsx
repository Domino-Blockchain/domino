import React from "react";
import { DominoClusterStatsProvider } from "./dominoClusterStats";

type Props = { children: React.ReactNode };
export function StatsProvider({ children }: Props) {
  return <DominoClusterStatsProvider>{children}</DominoClusterStatsProvider>;
}
