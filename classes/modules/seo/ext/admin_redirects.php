<?php

class admin_redirects
{
    /**
     * onInit function
     *
     */
    public function onInit()
    {
        if (cmsController::getInstance()->getCurrentMode() != 'admin')
            return;
        $commonTabs = $this->getCommonTabs();
        if ($commonTabs) {
            $commonTabs->add('redirects');
        }
    }

    /**
     * Main redirects function
     * @return mixed
     */
    public function redirects()
    {

        $data = getRequest("data");

        if (sizeof($data)>0) {
            $sources = array();
            $redirects = redirects::getInstance();
            //проверяем текущие и обновляем
            if (!empty($data["old"])) {
                foreach ($data["old"] as $key => $item) {
                    self::update($key, $item["source"], $item["target"], $item["status"]);
                    $sources[$key] = $item["source"];
                }
            }
            //добавляем новые
            if (!empty($data["new"])) {
                foreach ($data["new"] as $newitem) {
                    $redirects->add($newitem["source"], $newitem["target"], $newitem["status"]);
                    if (in_array($newitem["source"], $sources)) {
                        $reverse = array_flip($sources);
                        $data["dels"][] = $reverse[$newitem["source"]];
                    }
                }
            }

            unset($reverse);
            unset($sources);
            //удаляем редиректы
            if (!empty($data["dels"])) {
                foreach ($data["dels"] as $item) {
                    $id = (int)$item;
                    if ($id > 0) $redirects->del($id);
                }
            }
            unset($data);
        }

        $this->setDataType("list");
        $this->setActionType("modify");
        $links = array('+link' => array());
        $errors = array('+error' => array());

        $sql = "SELECT `id`,`source`,`target`, `status` FROM `cms3_redirects`";
        $result = l_mysql_query($sql);
        while (list($id, $source, $target, $status) = mysql_fetch_row($result)) {
            $links["+link"][] = Array("+source" => array($source), "+target" => array($target), "@status" => (int)$status, "@id" => $id);
        }
        $data = array(
            "new" => array(
                "+item" => array(0, 1, 2)
            ),
            "statuses" => array(
                "+status" => array(301, 302)
            ),
            'links' => $links,
            'errors' => $errors
        );

        $this->setData($data);
        return $this->doData();
    }

    /**
     * Create new redirect
     * @return mixed
     */
    public function redirect_add()
    {
        $mode = (string)getRequest("param0");

        if ($mode == "do") {

        }

        $inputData = array();

        $this->setDataType("");
        $this->setActionType("create");

        $data = $this->prepareData($inputData, "object");

        $this->setData($data);
        return $this->doData();
    }

    /**
     * Update redirect record
     * @param $id
     * @param $source
     * @param $target
     * @param $status
     * @return bool
     */
    public function update($id, $source, $target, $status)
    {

        if (!$id || $id <= 0) return false;

        l_mysql_query("START TRANSACTION /* Modify redirect records */");
        $sql = <<<SQL
UPDATE `cms3_redirects`
	SET
	`source` = '{$source}', `target` = '{$target}', `status` = '{$status}'
	WHERE
	`id` = '{$id}'
SQL;
        l_mysql_query($sql);
        l_mysql_query("COMMIT");
        return true;
    }
}