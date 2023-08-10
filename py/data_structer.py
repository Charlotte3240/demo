from dataclasses import dataclass


# key 为 sessionId
@dataclass
class Session:
    father_node_id: str
    current_local_node_id: str
    round_cnt: int # 对话轮次 semantic_recognition 中➕1
    same_question_in_state_cnt: int
    same_question_cnt: int
    bottom_node_id_list: [str]  # node_id 列表
    topic_node_id_list: [str]  # node_id 列表
    nodepath_list: [str]  # node_id 列表
    real_duration: [str]  # 如果request中有 duration 和 playback_duration 字段就添加进来
    dialogue_history: [dict]  # 添加每次经过structure_return_params返回的字典return_params
    # 是否对话结束，初始值设置为false
    # 判断节点是否在 ending_node_ids 中，设置为true
    # dm中途发生了异常，但是存储了redis，再次从redis中恢复时判断 errorcode !=0 时 设置为true
    # round_cnt >= max_round 超过最大限制时 结束 设置为true
    # 调用状态转移模块时 没有找到hit_node 设置为true  NEXTNODE_IS_NOTEXIT
    dialogue_end: bool
    user_variables: dict  # 从request中获取的用户变量
    scene_id: str  # 场景id 实际为机器人id
    tenant_id: str  # 租户id
    scene_version: str  # 场景版本 实际为机器人版本


# key 为 CONFIG_{租户id}_{机器人id}_{机器人版本}
@dataclass
class RobotConfig:
    """
    看txt文件
    """


# 没有存储redis， 是从session 和config 数据拼接来的
@dataclass
class SessionState:
    subtree_to_global: dict  # 从config中获取
    business_question_lists: []  # 从config中获取
    label_infos: dict  # 从config中获取
    user_variables: dict  # 从session中恢复
    variable_manage: dict  # 从config中获取
    nodepath_list: [str]  # 从session中恢复
    bottomNode_list: [str]  # 从session中恢复 `bottom_node_id_list`
    first_robot_type: str  # 从config中获取
    intention_mode_id: str  # 从config 中获取，默认值为 `dianxiao_es_similarity`
    dialogue_history: [dict]  # 从session中恢复
    real_duration: [str]  # 从session中恢复
